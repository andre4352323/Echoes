using Godot;
using System.Collections.Generic;

public partial class Player : CharacterBody3D
{
	[Export] public float Speed = 5.0f;
	[Export] public float JumpVelocity = 4.5f;
	[Export] public float MouseSensitivity = 0.003f;

	private Node3D _head;
	private RayCast3D _interactRay;
	private Dictionary<string, int> _items = new();

	public override void _Ready()
	{
		_head = GetNode<Node3D>("Head");
		Input.MouseMode = Input.MouseModeEnum.Captured;
		_interactRay = GetNode<RayCast3D>("Head/Camera3D/RayCast3D");
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		if (@event is InputEventMouseMotion motion)
		{
			RotateY(-motion.Relative.X * MouseSensitivity);
			_head.RotateX(-motion.Relative.Y * MouseSensitivity);
			_head.Rotation = _head.Rotation with
			{
				X = Mathf.Clamp(_head.Rotation.X, Mathf.DegToRad(-89), Mathf.DegToRad(89))
			};
		}

		if(@event.IsActionPressed("interact"))
		{
			TryInteract();
		}
	}

	private void TryInteract()
	{
		if (!_interactRay.IsColliding())
		{
			return;
		}

		var hit = _interactRay.GetCollider();
		if (hit is Interactable target)
		{
			target.Interact(this);
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector3 velocity = Velocity;

		if (!IsOnFloor())
			velocity += GetGravity() * (float)delta;

		if (Input.IsActionJustPressed("jump") && IsOnFloor())
			velocity.Y = JumpVelocity;

		Vector2 input = Input.GetVector("move_left", "move_right", "move_forward", "move_back");
		Vector3 dir = Transform.Basis * new Vector3(input.X, 0, input.Y);
		velocity.X = dir.X * Speed;
		velocity.Z = dir.Z * Speed;

		Velocity = velocity;
		MoveAndSlide();
	}

	public void AddItem(string id, int amount)
	{
		_items.TryGetValue(id, out int current);
		_items[id] = current + amount;

		//maybe delete this to show the items in an UI
		GD.Print($"{id}: {_items[id]}");
	}

	public int GetItemCount(string id)
	{
		return _items.TryGetValue(id, out int count) ? count : 0;
	}


	//this method is for the ship to get rid of the items when i hande them over
	public bool RemoveItem(string id, int amount)
	{
		if (GetItemCount(id) < amount)
			return false;

		_items[id] -= amount;
		return true;
	}	
}
