# utilities JS/TS wrapper

Not all utilities functions found in Lua are supported, the ones that are will have a JS/TS example
on the documentation.

Currently, all the available functions for JS/TS can be found under the `resource` folder in  
utilities.

## Installation

```yaml
# With pnpm
pnpm add @overextended/utilities

# With Yarn
yarn add @overextended/utilities

# With npm
npm install @overextended/utilities
```

## Usage
You can either import the lib from client or server files or deconstruct the object and import only certain functions
you may require.

```ts
import lib from '@overextended/utilities/client'
```

```ts
import lib from '@overextended/utilities/server'
```

```ts
import { checkDependency } from '@overextended/utilities/shared';
```

## Documentation
[View documentation](https://overextended.github.io/docs/utilities)