pymd-conditional-comments
===========

This is a [python-markdown](https://github.com/waylan/Python-Markdown) preprocessor extension that allows you to conditionally uncomment HTML comment blocks based on configuration. 

Installation
------------

```sh
pip install git+https://github.com/oconnerj-atlas/pymd-conditional-comments.git
```

Why Use This Extension?
-----------------------

This extension has many possible uses. The most common use is to create markdown documents that can be rendered by many different engines, with incompatible blocks commented out. For example, not all engines have the same raw HTML support as `python-markdown`. Perhaps your markdown is using non-standard syntax provided by a `python-markdown` extension that other engines won't recognize. You can comment those blocks out, and rely on `pymd-conditional-comments` to uncomment them when rendering with `python-markdown`.

```html
<!-- This is a standard HTML comment. It will remain in the output (unless another extension removes it). -->
<!-- #pymd-if:my-condition <button>This only appears if my-condition is satisfied.</button> -->
```

Conditions
----------

As seen in the example above (`my-condition`), you can provide named conditions that must be satisfied in order for `pymd-conditional-comments` to uncomment the line. The extension doesn't actually provide any sort of evaluation engine; rather, the conditions are expected to be passed in at runtime. The intended usage is that the calling script or build pipeline will perform any necessary logic to determine which condition keys should be passed into the extension. A condition is considered satisfied so long as the named key exists.

Rules for condition keys:

* Condition keys cannot have spaces in them.
* Condition keys may include alphanumeric characters, dashes, and underscores only.
* There cannot be a space between the colon `:` and condition key in the syntax. 
    - For example, `#pymd-if:my-condition` is valid, but `#pymd-if: my-condition` is not.

Syntax
------

* `#pymd-if:(condition)` – When used at the start of an HTML comment, will uncomment the entire comment block if the given condition is met.
* `#pymd-remove-if:(condition)` / `#pymd-end` – When used in paired comments, the engine will remove those comments and everything between them.
    - This is often used alongside `#pymd-if` to create alternate versions of a document.

Examples
--------

In this example, the first version is the default and will render in all engines. The first version will be commented out by all engines as well. However, in `python-markdown`, with this extension, the first version will be removed and the second version uncommented if the `superscript-enabled` condition is met.

```html
<!-- #pymd-remove-if:superscript-enabled -->
First version: The value of 2<sup>2</sup> is 4.
<!-- #pymd-end -->
<!-- #pymd-if:superscript-enabled 
Second version: The value of 2^2^ is 4.
-->
```

Python Usage Example
--------------------

TODO: improve this example, make sure to provide a good multiline example too, show how to pass in conditions

```python
>>> import markdown
>>> import pymd-conditional-comments
>>> comments = pymd-conditional-comments.Extension()
>>> markdowner = markdown.Markdown(extensions=[comments])
>>> markdowner.convert("""\
... blah blah blah  <!--- inline comment -->
...
... <!---multiline comment
... multiline comment
... multiline comment-->
...
... even more text.""")
u'<p>blah blah blah</p>\n<p>even more text.</p>'
```

Infrequently Asked Questions
----------------------------

### How can I write about the conditional comments without them being removed?

The regex that powers the substitutions is fairly basic. It will only match the exact string "`<!-- #pymd-if:`" in the pre-processed markdown. Even then, the comments will only be uncommented if the condition is met, so using an unmet condition would still technically work. However, the engine will still treat it like an HTML comment.

So, much like with normal HTML comments, use the HTML-encoded representations for the greater-than and less-than characters:

```html
&lt;!-- #pymd-if:my-condition &lt;button&gt;This only appears if my-condition is satisfied.&lt;/button&gt;
```
