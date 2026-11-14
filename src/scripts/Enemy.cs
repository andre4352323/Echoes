using Godot;

public partial class Enemy : CharacterBody3D
{
	[Export] public float Speed = 4.0f;         
	[Export] public float DetectRange = 30.0f;  
	[Export] public float StealRange = 2.0f;     
	[Export] public float StealCooldown = 3.0f;  

	private Player _player;
	private double _cooldown;

	public override void _Ready()
	{
		_player = GetTree().GetFirstNodeInGroup("player") as Player;

		// find the walk animation inside the imported model and loop it
		var anim = FindChild("AnimationPlayer", true, false) as AnimationPlayer;
		if (anim != null)
		{
			foreach (string animName in anim.GetAnimationList())
			{
				if (animName == "RESET") continue;
				anim.GetAnimation(animName).LoopMode = Animation.LoopModeEnum.Linear;
				anim.Play(animName);
				break;
			}
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		if (_player == null) return;

		Vector3 velocity = Velocity;
		if (!IsOnFloor())
			velocity += GetGravity() * (float)delta;

		Vector3 toPlayer = _player.GlobalPosition - GlobalPosition;
		toPlayer.Y = 0;
		float dist = toPlayer.Length();

		// chase while the player is in range but not already touching
		if (dist < DetectRange && dist > StealRange * 0.8f)
		{
			Vector3 dir = toPlayer.Normalized();
			velocity.X = dir.X * Speed;
			velocity.Z = dir.Z * Speed;
			LookAt(new Vector3(_player.GlobalPosition.X, GlobalPosition.Y, _player.GlobalPosition.Z), Vector3.Up);
		}
		else
		{
			velocity.X = 0;
			velocity.Z = 0;
		}

		Velocity = velocity;
		MoveAndSlide();

		// steal one item when close enough and the cooldown is over
		_cooldown -= delta;
		if (dist <= StealRange && _cooldown <= 0)
		{
			string stolen = _player.StealRandomItem();
			if (stolen != null)
			{
				_player.ShowNotice($"The alien stole 1 {stolen.Replace("_", " ")}!");
				_cooldown = StealCooldown;
			}
		}
	}
}
