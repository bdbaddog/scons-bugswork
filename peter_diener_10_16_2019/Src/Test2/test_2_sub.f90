submodule(test_2) test_2_impl

contains

  module procedure set_m

    implicit none

    this%m = m
  end procedure set_m

  module procedure get_m

    implicit none

    get_m = this%m
  end procedure get_m

end submodule test_2_impl
