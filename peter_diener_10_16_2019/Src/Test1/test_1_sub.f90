submodule(test_1) test_1_impl

contains

  module procedure set_n

    implicit none

    this%n = n
  end procedure set_n

  module procedure get_n

    implicit none

    get_n = this%n
  end procedure get_n

end submodule test_1_impl
