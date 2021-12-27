declare module "sass-loader/dist/utils" {
  export function getWebpackResolver(
    resolverFactory: Function,
    implementation: Object,
    includes: string[],
  ): (prev: string, originalUrl: string, fromImport: boolean) => Promise<string>;
}
