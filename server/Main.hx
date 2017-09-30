import eweb.Web;

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
		Sys.println('Hello, Lab! (${Web.fromManagedCache ? "module cached" : "FIRST RUN"})');
#if client_traces
		trace("example: execute'd");
#end
	}

	static function main()
	{
		var stderr = Sys.stderr();
		haxe.Log.trace = function (msg:Dynamic, ?pos:haxe.PosInfos) stderr.writeString('$msg\n');
		Web.traceCache = haxe.Log.trace;
		Web.addModuleFinalizer(finalize);
		Web.runAndCache(execute);
	}
}
