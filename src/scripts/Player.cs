using Godot;
using System.Collections.Generic;

public partial class Player : CharacterBody3D
{
	[Export] public float Speed = 3.0f;
	[Export] public float JumpVelocity = 4.5f;
	[Export] public float MouseSensitivity = 0.003f;

	private Node3D _head;
	private RayCast3D _interactRay;
	private Dictionary<string, int> _items = new();
	private Label _promptLabel;
	private Label _noticeLabel;
	private Tween _noticeTween;

	public override void _Ready()
	{
		_head = GetNode<Node3D>("Head");
		Input.MouseMode = Input.MouseModeEnum.Captured;
		_interactRay = GetNode<RayCast3D>("Head/Camera3D/RayCast3D");
		_promptLabel = GetNode<Label>("HUD/PromptLabel");
		AddToGroup("player");
		_noticeLabel = GetNode<Label>("HUD/NoticeLabel");
		_noticeLabel.Modulate = new Color(1, 1, 1, 0);
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

		public override void _Process(double delta)
	{
		string text = GetInteractPrompt();
		_promptLabel.Text = text;
		_promptLabel.Visible = text != "";
	}

	private string GetInteractPrompt()
	{
		if (!_interactRay.IsColliding())
			return "";

		var hit = _interactRay.GetCollider();
		if (GodotObject.IsInstanceValid(hit) && hit is Interactable target)
			return $"[E] {target.Prompt}";

		return "";
	}


		// removes 1 of a random item the player carries Returns its id, or null if empty
	public string StealRandomItem()
	{
		var available = new List<string>();
		foreach (var pair in _items)
			if (pair.Value > 0)
				available.Add(pair.Key);

		if (available.Count == 0)
			return null;

		string id = available[GD.RandRange(0, available.Count - 1)];
		_items[id] -= 1;
		return id;
	}

	public void ShowNotice(string text)
	{
		_noticeLabel.Text = text;
		_noticeLabel.Modulate = new Color(1, 1, 1, 1);

		_noticeTween?.Kill();
		_noticeTween = CreateTween();
		_noticeTween.TweenInterval(1.5);
		_noticeTween.TweenProperty(_noticeLabel, "modulate:a", 0.0f, 0.8f);
	}
}
