import { ArgumentParser } from "argparse";
import * as sass from "sass";
import { getWebpackResolver } from "sass-loader/dist/utils";
import { createVfs } from "@better-rules-javascript/nodejs-fs-linker/package";
import { WrapperVfs } from "@better-rules-javascript/nodejs-fs-linker/vfs";
import { PackageTree } from "@better-rules-javascript/commonjs-package";
import { JsonFormat } from "@better-rules-javascript/util-json";
import * as fs from "fs";
import * as resolve from "enhanced-resolve";
import { promisify } from "util";
import * as path from "path";

function getResolver(options: any) {
  const resolver = resolve.create(options);
  return (context: string, request: string, callback: Function) => {
    return resolver({}, context, request, {}, <any>callback);
  };
}

function importer(): sass.LegacyAsyncImporter {
  const resolver = getWebpackResolver(getResolver, sass, []);
  return function (originalUrl, prev, done) {
    const { fromImport } = this;
    resolver(prev, originalUrl, fromImport).then(
      (file) => {
        done({ file });
      },
      (e) => {
        done(e);
      },
    );
  };
}

interface SassArgs {
  manifest: string;
  output: string;
  map: string;
  src: string;
}

export class SassError extends Error {}

class WorkerArgumentParser extends ArgumentParser {
  exit(status: number, message: string) {
    throw new SassError(message);
  }
}

export class SassWorker {
  constructor(private readonly vfs: WrapperVfs) {
    this.parser = new WorkerArgumentParser();
    this.parser.add_argument("--manifest", { required: true });
    this.parser.add_argument("src");
    this.parser.add_argument("output");
    this.parser.add_argument("map");
  }

  private readonly parser: ArgumentParser;

  private setupVfs(manifest: string) {
    const packageTree = JsonFormat.parse(
      PackageTree.json(),
      fs.readFileSync(manifest, "utf8"),
    );
    const vfs = createVfs(packageTree, false);
    this.vfs.delegate = vfs;
  }

  async run(a: string[]) {
    const args: SassArgs = this.parser.parse_args(a);

    this.setupVfs(args.manifest);

    const options: sass.LegacyOptions<"async"> = {
      importer: importer(),
      file: args.src,
      sourceMap: args.map,
    };
    const render = promisify(sass.render);
    let result: sass.LegacyResult;
    try {
      result = await render(options);
    } catch (e) {
      if (e && e.formatted) {
        throw new SassError(e.formatted);
      }
      throw e;
    }

    await fs.promises.mkdir(path.dirname(args.output), { recursive: true });
    await fs.promises.writeFile(args.output, result.css);
    await fs.promises.writeFile(args.map, result.map);
  }
}
