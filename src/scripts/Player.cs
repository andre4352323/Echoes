using Godot;
using System.Collections.Generic;

public partial class Player : CharacterBody3D
{
	[Export] public float Speed = 5.0f;
	[Export] public float JumpVelocity = 4.5f;
	[Export] public float MouseSensitivity = 0.003f;
	[Export] public float StealInterval = 60.0f;   // seconds between steals

	private Node3D _head;
	private RayCast3D _interactRay;
	private Label _promptLabel;
	private Label _noticeLabel;
	private Tween _noticeTween;

	private Dictionary<string, int> _items = new();
	private List<string> _history = new();   // order of pickups, last = most recent
	private double _stealTimer;

	public override void _Ready()
	{
		_head = GetNode<Node3D>("Head");
		_interactRay = GetNode<RayCast3D>("Head/Camera3D/RayCast3D");
		_promptLabel = GetNode<Label>("HUD/PromptLabel");
		_noticeLabel = GetNode<Label>("HUD/NoticeLabel");

		_noticeLabel.Modulate = new Color(1, 1, 1, 0);
		_stealTimer = StealInterval;
		AddToGroup("player");
		Input.MouseMode = Input.MouseModeEnum.Captured;
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

		if (@event.IsActionPressed("interact"))
			TryInteract();
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

	public override void _Process(double delta)
	{
		// Interaction prompt
		string text = GetInteractPrompt();
		_promptLabel.Text = text;
		_promptLabel.Visible = text != "";

		// Steal timer
		_stealTimer -= delta;
		if (_stealTimer <= 0)
		{
			_stealTimer = StealInterval;
			StealLatestItem();
		}
	}

	// ---------- Interaction ----------

	private void TryInteract()
	{
		if (!_interactRay.IsColliding())
			return;

		var hit = _interactRay.GetCollider();
		if (GodotObject.IsInstanceValid(hit) && hit is Interactable target)
			target.Interact(this);
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

	// ---------- Inventory ----------

	public void AddItem(string id, int amount)
	{
		_items.TryGetValue(id, out int current);
		_items[id] = current + amount;

		for (int i = 0; i < amount; i++)
			_history.Add(id);

		GD.Print($"{id}: {_items[id]}");
	}

	public int GetItemCount(string id)
	{
		return _items.TryGetValue(id, out int count) ? count : 0;
	}

	// Used by the ship when you hand items over.
	public bool RemoveItem(string id, int amount)
	{
		if (GetItemCount(id) < amount)
			return false;

		_items[id] -= amount;

		for (int i = 0; i < amount; i++)
		{
			int idx = _history.LastIndexOf(id);
			if (idx >= 0) _history.RemoveAt(idx);
		}
		return true;
	}

	// ---------- Stealing ----------

	private void StealLatestItem()
	{
		if (_history.Count == 0)
			return;   // nothing to steal

		string id = _history[_history.Count - 1];
		_history.RemoveAt(_history.Count - 1);
		_items[id] -= 1;

		ShowNotice($"Something stole your {id.Replace("_", " ")}!");
	}

	public void ShowNotice(string text)
	{
		_noticeLabel.Text = text;
		_noticeLabel.Modulate = new Color(1, 1, 1, 1);

		_noticeTween?.Kill();
		_noticeTween = CreateTween();
		_noticeTween.TweenInterval(2.5);
		_noticeTween.TweenProperty(_noticeLabel, "modulate:a", 0.0f, 0.8f);
	}

		public string StealRandomItem()
	{
		return null;
	}
}
