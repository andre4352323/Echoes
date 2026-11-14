using Godot;
using System.Collections.Generic;

public partial class Ship : StaticBody3D, Interactable
{
	[Export] public Godot.Collections.Dictionary<string, int> Requirements = new();

	private Dictionary<string, int> _delivered = new();

	public string Prompt => IsComplete() ? "Launch ship" : "Repair ship\n" + GetProgressText();

	public void Interact(Player player)
	{
		if (IsComplete())
		{
			GD.Print("You win!");
			return;
		}

		foreach (var (id, needed) in Requirements)
		{
			_delivered.TryGetValue(id, out int have);
			int missing = needed - have;
			if (missing <= 0) continue;

			// give as much as the player owns, up to what's missing
			int toGive = Mathf.Min(missing, player.GetItemCount(id));
			if (toGive > 0 && player.RemoveItem(id, toGive))
				_delivered[id] = have + toGive;
		}

		GD.Print(GetProgressText());

		if (IsComplete())
			GD.Print("Ship repaired!");
	}

	private bool IsComplete()
	{
		foreach (var (id, needed) in Requirements)
		{
			_delivered.TryGetValue(id, out int have);
			if (have < needed) return false;
		}
		return true;
	}

	private string GetProgressText()
	{
		var lines = new List<string>();
		foreach (var (id, needed) in Requirements)
		{
			_delivered.TryGetValue(id, out int have);
			lines.Add($"{id} {have}/{needed}");
		}
		return string.Join(", ", lines);
	}
}
