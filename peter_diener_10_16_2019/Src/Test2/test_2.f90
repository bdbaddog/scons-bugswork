module test_2

  type test_type_2
    integer :: m
    contains
      procedure :: set_m
      procedure :: get_m
  end type test_type_2


interface

  module subroutine set_m ( this, m )
    class(test_type_2), intent(inout) :: this
    integer, intent(in) :: m
  end subroutine

  module function get_m ( this )
    class(test_type_2), intent(in) :: this
    integer :: get_m
  end function get_m

end interface

end module test_2
