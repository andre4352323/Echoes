using Godot;

public partial class Pickup : StaticBody3D, Interactable
{
    [Export] public string ItemId = "";     
    [Export] public string DisplayName = "";  
    [Export] public int Amount = 1;

    public string Prompt => $"Pick up {DisplayName}";


	public override void _Ready()
	{
		if (ItemId == "")
			GD.PushWarning($"{Name} has no ItemId set");
	}

    public void Interact(Player player)
    {
        player.AddItem(ItemId, Amount);
        QueueFree();
    }
}
