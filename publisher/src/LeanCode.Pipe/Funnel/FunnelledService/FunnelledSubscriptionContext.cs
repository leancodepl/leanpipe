namespace LeanCode.Pipe.Funnel.FunnelledService;

internal class FunnelledSubscribeContext : ISubscribeContext
{
    public IEnumerable<string>? GroupKeys { get; private set; }

    public Task AddToGroupsAsync(IEnumerable<string> groupKeys, CancellationToken ct)
    {
        PopulateGroupKeys(groupKeys);

        return Task.CompletedTask;
    }

    public Task RemoveFromGroupsAsync(IEnumerable<string> groupKeys, CancellationToken ct)
    {
        PopulateGroupKeys(groupKeys);

        return Task.CompletedTask;
    }

    private void PopulateGroupKeys(IEnumerable<string> groupKeys)
    {
        if (GroupKeys is null)
        {
            GroupKeys = groupKeys;
        }
        else
        {
            throw new InvalidOperationException("Group keys are already populated.");
        }
    }
}
