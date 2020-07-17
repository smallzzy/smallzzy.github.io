---
layout: post
title: 
date: 2020-07-17 13:01
category: 
author: 
tags: []
summary: 
---

## module

* In node.js, `module` is a plain js object with `exports` property
  * CommonJS defines `exports` instead of `module.exports`
  * node.js present `exports` as a short cut to `module.exports`
    * exports can be overwritten and will cause issues

```js
// node js
// default export
module.exports = Add;
const Add = require("math"); // arbitrary
// named export
module.exports.Add = Add;
const Add = require("math").Add; // const name is arbitrary
const {Add:name} = require("math"); // destructuring object
```

```js
// javascript es6
// default export?
// actually a named export with default being a reserved namespace
// https://stackoverflow.com/questions/40294870/module-exports-vs-export-default-in-node-js-and-es6
export default class Add {}
import Add from "./math.js"; // arbitrary
// named export
export class Add {}
import {Add} from "./math.js" // not arbitrary, not destructuring
```

[module](https://stackoverflow.com/questions/16383795/difference-between-module-exports-and-exports-in-the-commonjs-module-system)
[destructuring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)
