# Altera Quartus 13 dockerized 

Files in this repository allow for running Quartus 13.0 Service Pack 1 in a Docker container. Why would anyone want to run such an old release? It was the last version to support **Cyclone** FPGAs,  as well as **MAX7000** families and compatible **ATF150x** CPLDs from Atmel/Microchip (which is exactly my use case, it's probably the last 5V CPLD family still manufactured).

If you encounter any further issues or have any improvement ideas, submit an issue or pull request.

## Important notes

* the resulting Docker image is big - **20.6GB** on my PC. 

* it needs X11, no Wayland, sorry!

* Docker image uses `Ubuntu 14.04.6 LTS` as its base image. Anything newer caused more problems for me. 

* gate-level simulation under ModelSim doesn't work out of the box for some reason. It loads my test design (for MAX7032S), but complains about missing `max_io` and `max_mcell` components (which are parts of `max_ver` simulation library):

  ```
  # ** Error: (vsim-3033) addr_dec_io.vo(387): Instantiation of 'max_io' failed. The design unit was not found.
  #         Region: /addr_dec_io
  #         Searched libraries:
  #             /home/czajnik/work/e800j_rev/addr_dec/io/simulation/modelsim/gate_work
  ```

  However, if I try to start the simulation manually like this, everything works as expected:

  ```
  ModelSim> vsim -L max_ver gate_work.addr_dec_io
  # vsim -L max_ver gate_work.addr_dec_io 
  # Loading gate_work.addr_dec_io
  # Loading max_ver.max_io
  # Loading max_ver.max_asynch_io
  # Loading max_ver.max_mcell
  # Loading max_ver.max_asynch_mcell
  # Loading max_ver.max_mcell_register
  # SDF 10.1d Compiler 2012.11 Nov  2 2012
  # Loading instances from addr_dec_io_v.sdo
  # Loading timing data from addr_dec_io_v.sdo
  # ** Note: (vsim-3587) SDF Backannotation Successfully Completed.
  #    Time: 0 ps  Iteration: 0  Instance: /addr_dec_io File: addr_dec_io.vo
  ```

  I don't know why it doesn't work by default, and I have better things to do with my life than digging through the TCL scripts. If you know how to fix it, let me know.

* programming tool successfully opened my USB Blaster clone, but I'm yet to try to actually program any part. Note: you may need to tweak device permissions with proper `udev` rules.

## Building the Docker image

How to build the image:

* download `Quartus-web-13.0.1.232-linux.tar` file from Intel into this directory

  ```
  $ sha1sum Quartus-web-13.0.1.232-linux.tar
  2b110eff0d544bcda4013e265f6feaa507482357  Quartus-web-13.0.1.232-linux.tar
  ```

* you may also try Quartus 13.1, but it was not my focus, so it's not fully tested

  ```
  $ sha1sum Quartus-web-13.1.0.162-linux.tar 
  52dc519e7bd061b5e5fdcc537241b0f7983f2558  Quartus-web-13.1.0.162-linux.tar
  ```
  
  You also need to uncomment the right line in `build.sh`:
  
  ```sh
  # Select 13.0 or 13.1 here
  TARBALL=Quartus-web-13.0.1.232-linux.tar
  #TARBALL=Quartus-web-13.1.0.162-linux.tar
  ```
  
* build the container image (default tag: `quartus:13`) with:

  ```sh
  $ ./build.sh
  ```

## Running it 

See [bin](bin) for scripts:

* `q13_spawn` starts a container named `quartus13` (you can override it via `CONTAINER_NAME` env variable) and executes whatever command is given as argument. 

  * you can use it to directly execute any Quartus tool in a container, e.g. Quartus State Machine Editor:

    ```
    $ ./bin/q13_spawn qsme
    ```

  * it runs with current user's UID /GID and mounts user's home directory, so you can feel at home, literally :)
  
  * the container is started in the background (`-d`) and removed after exit (`--rm`). In case of any troubles, it might be useful to remove `--rm` temporarily (e.g. to check the logs).

* `quartus` script is a 1-liner calling `q13_spawn quartus` to start the main Quartus GUI.

* `vsim` scripts starts a ModelSim (Altera Starter Edition) session.
