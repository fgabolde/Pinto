# ABSTRACT: Black hole interface

package Pinto::Chrome::Null;

use Moose;
use MooseX::StrictConstructor;
use MooseX::MarkAsMethods (autoclean => 1);

#-----------------------------------------------------------------------------

# VERSION

#-----------------------------------------------------------------------------

extends qw( Pinto::Chrome );

#-----------------------------------------------------------------------------

sub show { return 1 };

#-----------------------------------------------------------------------------

sub diag { return 1 };

#-----------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable;

#-----------------------------------------------------------------------------
1;

__END__


