using Godot;

public partial class ViewManager : Node
{
	[Export] public Player PlayerNode;
	[Export] public Node3D[] NormalZones;  
	[Export] public Node3D[] HiddenZones;   
	[Export] public float ScanDuration = 30.0f;
	[Export] public float Cooldown = 10.0f;
	[Export] public float WarningTime = 10.0f;

	private const int NormalLayer = 5;
	private const int ScannedLayer = 4;

	private RayCast3D _ray;
	private RichTextLabel _hint;
	private Label _timerLabel;
	private bool _scanned;
	private double _timeLeft;
	private double _cooldownLeft;

	public override void _Ready()
	{
		_ray = PlayerNode.GetNode<RayCast3D>("Head/Camera3D/RayCast3D");
		_hint = PlayerNode.GetNode<RichTextLabel>("HUD/KeyHint");
		_timerLabel = PlayerNode.GetNode<Label>("HUD/TimerLabel");

		foreach (Node3D zone in NormalZones)
			SetLayerRecursive(zone, 1u << (NormalLayer - 1));
		foreach (Node3D zone in HiddenZones)
			SetLayerRecursive(zone, 1u << (ScannedLayer - 1));

		SetView(false);
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		if (@event.IsActionPressed("scan") && !_scanned && _cooldownLeft <= 0)
		{
			_timeLeft = ScanDuration;
			SetView(true);
		}
	}

	public override void _Process(double delta)
	{
		if (_scanned)
		{
			_timeLeft -= delta;
			if (_timeLeft <= 0)
			{
				SetView(false);
				_cooldownLeft = Cooldown;
			}
		}
		else if (_cooldownLeft > 0)
		{
			_cooldownLeft -= delta;
		}

		UpdateUI();
	}

	private void SetView(bool scanned)
	{
		_scanned = scanned;

		foreach (Node3D zone in NormalZones)
			Apply(zone, !scanned);
		foreach (Node3D zone in HiddenZones)
			Apply(zone, scanned);

		
		PlayerNode.SetCollisionMaskValue(NormalLayer, !scanned);
		PlayerNode.SetCollisionMaskValue(ScannedLayer, scanned);
		_ray.SetCollisionMaskValue(NormalLayer, !scanned);
		_ray.SetCollisionMaskValue(ScannedLayer, scanned);
	}

	private static void Apply(Node3D zone, bool on)
	{
		zone.Visible = on;
		zone.ProcessMode = on ? ProcessModeEnum.Inherit : ProcessModeEnum.Disabled;
	}

	private void UpdateUI()
	{
		// red pulsing countdown, only during the last seconds of the scan
		if (_scanned && _timeLeft <= WarningTime)
		{
			_timerLabel.Visible = true;
			_timerLabel.Text = Mathf.CeilToInt((float)_timeLeft).ToString();
			float t = (float)Time.GetTicksMsec() / 1000f;
			_timerLabel.Modulate = new Color(1, 1, 1, 0.2f + 0.8f * Mathf.Abs(Mathf.Sin(t * 4f)));
		}
		else
		{
			_timerLabel.Visible = false;
		}

		// key hint only when the scan is available
		if (_scanned)
		{
			_hint.Text = "";
		}
		else if (_cooldownLeft > 0)
		{
			_hint.Text = $"[right][color=gray]Scanner recharging {Mathf.CeilToInt((float)_cooldownLeft)}s[/color][/right]";
		}
		else
		{
			_hint.Text = $"[right][color=cyan][lb]{KeyName("scan")}[rb][/color] Scan[/right]";
		}
	}

	private static string KeyName(string action)
	{
		foreach (var ev in InputMap.ActionGetEvents(action))
		{
			if (ev is InputEventKey k)
			{
				Key key = k.PhysicalKeycode != Key.None ? k.PhysicalKeycode : k.Keycode;
				return OS.GetKeycodeString(key);
			}
		}
		return "?";
	}

	private static void SetLayerRecursive(Node node, uint layer)
	{
		if (node is CollisionObject3D body)
			body.CollisionLayer = layer;

		foreach (Node child in node.GetChildren())
			SetLayerRecursive(child, layer);
	}
}
