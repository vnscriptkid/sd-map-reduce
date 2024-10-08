# sd-map-reduce

## Notes
![Screenshot 2024-06-23 at 4 40 07 PM](https://github.com/vnscriptkid/sd-map-reduce/assets/28957748/f5f8af5c-cb39-4b5d-8f96-96eaa109d719)
- Whitepaper: https://static.googleusercontent.com/media/research.google.com/en//archive/mapreduce-osdi04.pdf
- N * Commodity machines
- Break files into chunks of: 16-256 MB (splits)
- 1 Master - N Workers
- Master keeps track of process of each Split (Which worker owns it, What's status)
- Worker gets data directly from source not through Master (reduce load for master)
- Worker processes data, store in RAM (fast), flush to disk, (may flush to distributed storage)
- E.g: slit 2D matrix, gg search
- Fault tolerance
  - Worker fails
    - How master knows work fails? Heartbeat
    - Scenarios:
      - Split A: Not completed -> Reassign to another worker
      - Split B: Completed but not yet flushed to Distributed storage -> Reassign to another worker
      - Split C: Completed and ALREADY pushed to Distributed storage -> N/A
  - Master fails: backup master (not mentioned in whitepaper)
- Output (stored in distributed storage)
  - #chunkFiles === #splits
- Improvements
  - Keeps data near processing workers (geographic location) 
- Map-Reduce model
- ![Screenshot 2024-06-23 at 5 31 06 PM](https://github.com/vnscriptkid/sd-map-reduce/assets/28957748/8ddc99d1-82ec-4703-a98b-2576bc2aad4d)
```js
const bigFile = `a b c a a d d d a`;
const split1 = `a b c` // -> worker1
const split2 = `a a d` // -> worker2
const split3 = `d d a` // -> worker3

// Map step
// Worker 1
const split1Words = split1.split(' ') // ['a', 'b', 'c']
const map1 = {}
for (let word of split1Words) {
  if (!(word in map1)) map1[word] = 0;
  map1[word] += 1;
}
// split1: {a: 1, b: 1: c: 1}

// Worker 2
// split2: {a: 2, d: 1}

// Worker 3
// split3: {d: 2, a: 1}

// Reduce step
const bigMap = {
  split1: {a: 1, b: 1, c: 1},
  split2: {a: 2, d: 1},
  split3: {d: 2, a: 1}
}

const finalOutput = reduce(bigMap)
// { a: 4, b: 1, c: 1, d: 3 }

```

## QnA
- What determine the number of nodes that run map tasks?
  - Number of data splits (blocks), number of nodes available
  - 1Gb data ~ 8 splits (128MB) -> 8 nodes if possible
- What determine the number of reducers?
  - By default, there's 1 reducer (1 node that processes reducer task)
  - We can customize that as arg during startup
![image](https://github.com/user-attachments/assets/ffda9e54-c6f6-4a8a-abf5-a5402d099e0d)

