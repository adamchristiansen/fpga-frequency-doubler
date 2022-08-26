# Frequency Doubler

Implement a frequency doubler in an FPGA.

The `constraints.xdc` file in this project targets a
[Digilent Arty](https://digilent.com/reference/programmable-logic/arty/start)
having a Xilinx Artix-7 XC7A35TICSG324-1L.

The conenctions on the Arty are summarized below:

| Design Name | Arty Pin | Description                   |
|-------------|----------|-------------------------------|
| `double_en` | SW0      | Enable doubling               |
| `enable_n`  | SW1      | Active low output enable      |
| `y`         | IO12     | Signal out                    |
| `x`         | IO13     | Signal in                     |
| `led(0)`    | LD4      | Always on, indicates power on |
| `led(1)`    | LD5      | On when doubling is enabled   |
| `led(2)`    | LD6      | Blinks at input frequency     |
| `led(3)`    | LD7      | Blinks at output frequency    |

A digital signal in `x` with a frequency from 50 mHz to 25 MHz is doubled and
output on `y`. While the system supports inputs up to 25 MHz, the signal
quality drops above 1 MHz.

The frequency of `x` may be changed at any time while the system is running,
and the output signal will change accordingly.

When doubling is not enabled, `x` is simply forwarded to `y` with a delay of
44 ± 2 ns. When doubling is enabled, `y` has a delay of 70 ± 4 ns relative to
`x`.

The output is always synchronized to the rising edge of the input, so the
delays quoted above are the delay for `y` to rise relative to `x`.



## License

This project is licensed under the MIT license. Please refer to the
[`LICENSE`](./LICENSE) file for the full text.
