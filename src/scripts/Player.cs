using Godot;

public partial class Player : CharacterBody3D
{
	[Export] public float Speed = 5.0f;
	[Export] public float JumpVelocity = 4.5f;
	[Export] public float MouseSensitivity = 0.003f;

	private Node3D _head;
	private RayCast3D _interactRay;

	public override void _Ready()
	{
		_head = GetNode<Node3D>("Head");
		Input.MouseMode = Input.MouseModeEnum.Captured;
		_interactRay = GetNode<RayCast3D>("Head/Camera3d/InteractRay");
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
}
