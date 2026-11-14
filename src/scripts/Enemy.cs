using Godot;

public partial class Enemy : CharacterBody3D
{
	[Export] public float Speed = 4.0f;          // player walks at 5, so you can outrun it
	[Export] public float DetectRange = 30.0f;   // starts chasing inside this distance
	[Export] public float StealRange = 2.0f;     // how close it must be to steal
	[Export] public float StealCooldown = 3.0f;  // seconds between steals

	private Player _player;
	private double _cooldown;

	public override void _Ready()
	{
		_player = GetTree().GetFirstNodeInGroup("player") as Player;

		// Find the walk animation, loop it, and remove forward movement so it plays in place.
		var anim = FindChild("AnimationPlayer", true, false) as AnimationPlayer;
		if (anim != null)
		{
			foreach (string animName in anim.GetAnimationList())
			{
				if (animName == "RESET") continue;

				Animation a = anim.GetAnimation(animName);
				a.LoopMode = Animation.LoopModeEnum.Linear;

				for (int i = a.GetTrackCount() - 1; i >= 0; i--)
				{
					if (a.TrackGetType(i) == Animation.TrackType.Position3D &&
						a.TrackGetPath(i).ToString().EndsWith("Hips"))
						a.RemoveTrack(i);
				}

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

		// Chase while the player is in range but not already touching.
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

		// Steal one item when close enough and the cooldown is over.
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
