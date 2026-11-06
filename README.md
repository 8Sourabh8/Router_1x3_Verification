# 1x3 Packet Router Verification (UVM)

UVM testbench for a 1x3 packet router. Packets arrive on one source port and are
sent to one of three destination ports according to the address in the header.

**Packet format:** header byte (`[7:2]` payload length 1 to 63, `[1:0]` destination 0, 1 or 2),
payload bytes, then a parity byte equal to the XOR of the header and all payload bytes.

## Design under test (`rtl/`)

| Block | Job |
|---|---|
| `router_fsm.v` | controls the packet flow: decode address, load header, payload and parity, FIFO-full handling, parity check |
| `router_reg.v` | holds the header, computes the internal parity, raises `err` on a parity mismatch |
| `router_sync.v` | latches the address, steers the write enable to the right FIFO, drives `vld_out`, soft-resets a FIFO whose destination does not read within 30 clocks |
| `router_fifo.v` | three 16 x 9 FIFOs (9th bit marks the header) |

## Testbench

- **Source agent:** drives packets (small 1–14, medium 15–40, large 41–63 bytes, and bad-parity packets), waits on `busy`.
- **Three destination agents:** read each port after a random delay; delays of 31–40 clocks trigger the soft reset.
- **Virtual sequencer and virtual sequences** start source and destination traffic together.
- **Scoreboard:**
  - compares header, payload and parity of every delivered packet with the packet that was sent;
  - checks the router's `err` output: it must be 1 exactly when the parity byte is wrong (reference parity = XOR of header and payload);
  - counts packets dropped by soft reset;
  - coverage crosses address × payload size × error on the source side and address × read delay (soft reset) on the destination side.

## Tests

`router_dst0_test`, `router_dst1_test`, `router_dst2_test` (traffic to each port) and `router_sreset_test` (soft reset on all three ports).

```
cd sim
make run_test      # see the Makefile for the full list and regression target
```

Tools: Verilog, SystemVerilog, UVM, Synopsys VCS / Siemens QuestaSim, SpyGlass lint.
