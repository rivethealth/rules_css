<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="#sass_bundle"></a>

## sass_bundle

<pre>
sass_bundle(<a href="#sass_bundle-name">name</a>, <a href="#sass_bundle-compiler">compiler</a>, <a href="#sass_bundle-dep">dep</a>, <a href="#sass_bundle-main">main</a>, <a href="#sass_bundle-out">out</a>, <a href="#sass_bundle-root">root</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="sass_bundle-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="sass_bundle-compiler"></a>compiler |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |
| <a id="sass_bundle-dep"></a>dep |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |
| <a id="sass_bundle-main"></a>main |  -   | String | required |  |
| <a id="sass_bundle-out"></a>out |  -   | String | required |  |
| <a id="sass_bundle-root"></a>root |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |


<a id="#sass_compiler"></a>

## sass_compiler

<pre>
sass_compiler(<a href="#sass_compiler-name">name</a>, <a href="#sass_compiler-bin">bin</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="sass_compiler-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="sass_compiler-bin"></a>bin |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |


<a id="#sass_library"></a>

## sass_library

<pre>
sass_library(<a href="#sass_library-name">name</a>, <a href="#sass_library-deps">deps</a>, <a href="#sass_library-prefix">prefix</a>, <a href="#sass_library-root">root</a>, <a href="#sass_library-srcs">srcs</a>, <a href="#sass_library-strip_prefix">strip_prefix</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="sass_library-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="sass_library-deps"></a>deps |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="sass_library-prefix"></a>prefix |  Prefix   | String | optional | "" |
| <a id="sass_library-root"></a>root |  -   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |
| <a id="sass_library-srcs"></a>srcs |  Sass sources   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="sass_library-strip_prefix"></a>strip_prefix |  Strip prefix.   | String | optional | "" |


<a id="#configure_sass_compiler"></a>

## configure_sass_compiler

<pre>
configure_sass_compiler(<a href="#configure_sass_compiler-name">name</a>, <a href="#configure_sass_compiler-sass">sass</a>, <a href="#configure_sass_compiler-visibility">visibility</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="configure_sass_compiler-name"></a>name |  <p align="center"> - </p>   |  none |
| <a id="configure_sass_compiler-sass"></a>sass |  <p align="center"> - </p>   |  none |
| <a id="configure_sass_compiler-visibility"></a>visibility |  <p align="center"> - </p>   |  <code>None</code> |


