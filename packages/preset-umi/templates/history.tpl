import { createHashHistory, createMemoryHistory, createBrowserHistory, History } from '{{{ historyPath }}}';

let history: History;
let basename: string = '/';
export function createHistory(opts: any) {
  let h;
  if (opts.type === 'hash') {
    h = createHashHistory();
  } else if (opts.type === 'memory') {
    h = createMemoryHistory(opts);
  } else {
    h = createBrowserHistory();
  }
  if (opts.basename) {
    basename = opts.basename;
  }
  history = h;
  const oldPush = h.push;
  history.push = (to, state) => {
    oldPush(patchTo(to), state);
  };
  const oldReplace = h.replace;
  history.replace = (to, state) => {
    oldReplace(patchTo(to), state);
  };
  return h;
}

// Patch `to` to support basename
// Refs:
// https://github.com/remix-run/history/blob/3e9dab4/packages/history/index.ts#L484
// https://github.com/remix-run/history/blob/dev/docs/api-reference.md#to
function patchTo(to: any) {
  if (typeof to === 'string') {
    return `${stripLastSlash(basename)}${to}`;
  } else if (typeof to === 'object' && to.pathname) {
    return {
      ...to,
      pathname: `${stripLastSlash(basename)}${to.pathname}`,
    };
  } else {
    throw new Error(`Unexpected to: ${to}`);
  }
}

function stripLastSlash(path) {
  return path.slice(-1) === '/' ? path.slice(0, -1) : path;
}

export { history };