module test_1

  type test_type_1
    integer :: n
    contains
      procedure :: set_n
      procedure :: get_n
  end type test_type_1


interface

  module subroutine set_n ( this, n )
    class(test_type_1), intent(inout) :: this
    integer, intent(in) :: n
  end subroutine

  module function get_n ( this )
    class(test_type_1), intent(in) :: this
    integer :: get_n
  end function get_n

end interface

end module test_1
