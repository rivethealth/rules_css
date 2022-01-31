import { workerMain } from "@better-rules-javascript/bazel-worker";
import { patchFs } from "@better-rules-javascript/nodejs-fs-linker/fs";
import { patchFsPromises } from "@better-rules-javascript/nodejs-fs-linker/fs-promises";
import { WrapperVfs } from "@better-rules-javascript/nodejs-fs-linker/vfs";

workerMain(async () => {
  const vfs = new WrapperVfs();
  patchFs(vfs, require("fs"));
  patchFsPromises(vfs, require("fs").promises);

  const { SassWorker, SassError } = await import("./worker");
  const worker = new SassWorker(vfs);

  return async (a) => {
    try {
      await worker.run(a);
    } catch (e) {
      if (e instanceof SassError) {
        return { exitCode: 2, output: e.message };
      }
      return { exitCode: 1, output: String(e?.stack || e) };
    }
    return { exitCode: 0, output: "" };
  };
});
