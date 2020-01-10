***************
Installing Vnum
***************

Bottle can be included in your project by adding the repository to your
`shard.yml` file.

Using `vpm <https://vpm.best/>`_

.. code-block::

  $ v install christopherzimmerman.num
  $ cp -a ~/.vmodules/christopherzimmerman/vnum/ ~/.vmodules/

Vnum relies on LaPACK and BLAS under the hood for many linear algebra routines.
In order to use the library, these must be present on your machine to be properly
linked.

For Debian, use ``libopenblas-dev`` and ``liblapack-dev``. For other operating systems review the relevant
installation instructions for that OS.
