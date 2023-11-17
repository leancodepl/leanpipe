namespace LeanCode.Pipe.ClientIntegrationTestsApp.Contracts;

public static class AuthConfig
{
    public static class Roles
    {
        public const string User = "user";
    }

    public static class KnownClaims
    {
        public const string UserId = "sub";
        public const string Role = "role";
    }
}
