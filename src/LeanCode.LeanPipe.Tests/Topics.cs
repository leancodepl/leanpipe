using LeanCode.Contracts;

namespace LeanCode.LeanPipe.Tests;

public abstract class AbstractTopic : ITopic { }

public class GenericTopic<T> : ITopic { }

public class Topic1 : ITopic { }

public class Topic2 : AbstractTopic { }
