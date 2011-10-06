package Pinto::Action::Update;

# ABSTRACT: Pull all the latest distributions into your repository

use Moose;

use MooseX::Types::Moose qw(Bool);
use Pinto::Types qw(URI);

use Exception::Class::TryCatch;

use namespace::autoclean;

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------
# ISA

extends 'Pinto::Action';

#------------------------------------------------------------------------------
# Moose Attributes

has source => (
    is       => 'ro',
    isa      => URI,
    required => 1,
);

#------------------------------------------------------------------------------
# Moose Roles

with qw(Pinto::Role::UserAgent);

#------------------------------------------------------------------------------

sub execute {
    my ($self) = @_;

    my $source = $self->source();
    $self->db->load_index($source);

    my $count = 0;
    my $foreigners = $self->db->get_all_distributions_from_origin($source);

    while ( my $dist = $foreigners->next() ) {

        my $ok = eval { $count += $self->_do_mirror($dist); 1 };

        if ( !$ok && catch my $e, ['Pinto::Exception'] ) {
            $self->add_exception($e);
            $self->whine($e);
            next;
        }
    }

    return 0 if not $count;
    $self->add_message("Updated $count distributions from $source");

    return 1;
}

#------------------------------------------------------------------------------

sub _do_mirror {
    my ($self, $dist) = @_;

    my $dest = $dist->native_path( $self->config->repos() );

    $self->debug("Skipping $dest: already fetched") and return 0 if -e $dest;
    $self->fetch(url => $dist->url(), to => $dest)   or return 0;

    $self->store->add_archive( $dest );

    return 1;
}

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#------------------------------------------------------------------------------

1;

__END__
