# sd-map-reduce

## Notes
![Screenshot 2024-06-23 at 4 40 07 PM](https://github.com/vnscriptkid/sd-map-reduce/assets/28957748/f5f8af5c-cb39-4b5d-8f96-96eaa109d719)
- Whitepaper: https://static.googleusercontent.com/media/research.google.com/en//archive/mapreduce-osdi04.pdf
- N * Commodity machines
- Break files into chunks of: 16-256 MB (splits)
- 1 Master - N Workers
- Master keeps track of process of each Split (Which worker owns it, What's status)
- Worker gets data directly from source not through Master (reduce load for master)
- Worker processes data, keeps locally, and flush to distributed storage
- TODO: Fault tolerance
