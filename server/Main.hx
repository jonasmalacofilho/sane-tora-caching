class Main {
	static function finalize()
	{
		trace("CLEANUP done");
	}

	static function execute(cached:Bool)
	{
		if (!cached) {
			var stderr = Sys.stderr();
			haxe.Log.trace = function (msg:Dynamic, ?pos:haxe.PosInfos) stderr.writeString('$msg\n');

			trace("FIRST RUN");
			var share = new SimpleShare<Array<{ module:neko.vm.Module, path:String, mtime:Float, finalize:Void->Void }>>("magic");
			var module = neko.vm.Module.local();
			var path = '${module.name}.n';
			var mtime = sys.FileSystem.stat(path).mtime.getTime();
			var magic = share.get(true);
			if (magic == null) {
				magic = [];
				share.set(magic);
			} else {
#if !leak
				var kept = [];
				for (i in magic) {
					if (i.module != module && i.module.name == module.name && i.mtime != mtime) {
						trace('garbage collect: ${i.module.name} (${Date.fromTime(i.mtime)})');
						i.finalize();
					} else {
						kept.push(i);
					}
				}
				magic = kept;
#end
				share.set(magic);
			}

			magic.push({
				module : module,
				path : path,
				mtime : mtime,
				finalize : finalize
			});
			trace('magic size: ${magic.length}');
		} else {
			trace("running from cached module");
		}

		Sys.sleep(Math.random());
		Sys.println('Hello, Lab! (${cached ? "module cached" : "FIRST RUN"})');
	}

	static function main()
	{
		if (!neko.Web.isTora)
			throw "Expected Tora";
		neko.Web.cacheModule(execute.bind(true));
		execute(false);
	}
}
