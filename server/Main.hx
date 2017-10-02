import eweb.ManagedModule;

class Main {
	static function finalize()
	{
#if client_traces
		trace("example: finalize called");
#end
	}

	static function execute()
	{
#if client_random_sleep
		Sys.sleep(Math.random());
#end
		Sys.println('Hello, Lab! (${ManagedModule.runningFromCache ? "module cached" : "FIRST RUN"})');
#if client_traces
		trace("example: execute'd");
#end
	}

	static function main()
	{
		var stderr = Sys.stderr();
		haxe.Log.trace = function (msg:Dynamic, ?pos:haxe.PosInfos) stderr.writeString('$msg\n');
		ManagedModule.log = haxe.Log.trace;
		ManagedModule.addModuleFinalizer(finalize, "example");
		ManagedModule.runAndCache(execute);
	}
}
