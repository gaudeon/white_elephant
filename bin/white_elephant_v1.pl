#!/usr/bin/env perl

=pod

=head1 NAME

white_elephant_v1.pl

=head1 SYNOPSIS

./white_elephant_v1.pl

=head1 DESCRIPTION

Modify the word list of individuals assigned to the $people variable and run it.

Developed for a dev team elephant exchange in 2013.

=head1 KNOWN BUGS

People can end up with same gift they started with when the script randomly assigns them.

=cut

use strict;
use warnings;

MAIN: {
    my $people = [ sort qw(list of indiviuals participating)];

    my $results = urandom({count => scalar @$people, max => scalar @$people});

    print sprintf("%-20s => %s\n", $people->[$_], $results->[$_]) for 0 .. (scalar @$people - 1);
}

sub urandom {
    my $args  = shift || die "args needed";

    die "count arg required" unless $args->{'count'};
    die "max arg required" unless $args->{'max'};

    srand (time ^ ($$ + ($$ << 15)));

    my %results;
    my @results;
    for(1 .. $args->{'count'}) {
        my $num = int(rand($args->{'max'}));
        while($results{$num}) {
            $num = int(rand($args->{'max'}));
        }
        $results{$num} = 1;
        push @results, $num;
    }

    return \@results;
}
