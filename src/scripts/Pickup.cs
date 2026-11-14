using Godot;

public partial class Pickup : StaticBody3D, Interactable
{
	[Export] public string ItemId = "";
	[Export] public string DisplayName = "";
	[Export] public int Amount = 1;
	[Export] public float RespawnTime = 300.0f;

	public string Prompt => $"Pick up {DisplayName}";

	private Node3D _visualRoot;
	private CollisionShape3D _collisionShape;

	public override void _Ready()
	{
		if (ItemId == "")
			GD.PushWarning($"{Name} has no ItemId set");

		_collisionShape = GetNodeOrNull<CollisionShape3D>("CollisionShape3D");

		// if we sit under a mesh, hide the mesh, otherwise hide the static
		//this is done so that i do not have to deal with the import of the assets being mesh the parent for ones
		_visualRoot = GetParent() is MeshInstance3D mesh ? mesh : this;
	}

	public void Interact(Player player)
	{
		player.AddItem(ItemId, Amount);
		SetActive(false);
		GetTree().CreateTimer(RespawnTime).Timeout += () => SetActive(true);
	}

	private void SetActive(bool active)
	{
		_visualRoot.Visible = active;
		_collisionShape?.SetDeferred(CollisionShape3D.PropertyName.Disabled, !active);
	}
}
