#!/usr/bin/env perl

=pod

=head1 NAME

white_elephant_v2.pl

=head1 SYNOPSIS

./white_elephant_v2.pl

=head1 DESCRIPTION

Start the program and use the menu system to setup the players then play the exchange. Rules that the script follows are also provided as a menu option in the script.

Developed for a dev team elephant exchange in 2014. Designed as an improvement over white_elephant_v1.pl

=head1 KNOWN BUGS

None. This one worked well for our exchange!

=cut

use Term::ANSIColor qw(:constants);

$SIG{'INT'} = $SIG{'QUIT'} = sub { print RESET; exit; };

WhiteElephant->new->run;
exit;

package WhiteElephant;

    use strict;
    use warnings;

    use Term::ANSIColor qw(:constants);
    use List::Util qw(shuffle);
    use Data::Debug;

    sub new { bless {}, shift; }

    sub run {
        my $self = shift;

        $self->init;

        while( $self->{'running'} ) {
            $self->menu;
        }
    }

    sub init {
        my $self = shift;

        $self->{'running'} = 1;
        $self->menu_state('main');
        $self->{'players'} = {};

        {
            no strict "refs";
            $self->{'menu'} = {
                map { $_ => *{'Menu::' . $_ . '::render' } }
                qw(main enter_player_name enter_player_present_id display_present_assignments display_play_order)
            };
            use strict "refs";
        }

    }

    sub menu {
        my $self = shift;

        $self->cls;

        $self->{'menu'}{ $self->menu_state }();

        $self->render_output;

        $self->process( $self->cli );
    }

    sub menu_state {
        my $self       = shift;
        my $menu_state = shift;

        if($menu_state) {
            $self->last_menu_state( $self->{'menu_state'} );
            $self->{'menu_state'} = $menu_state;
        }

        return $self->{'menu_state'};
    }

    sub last_menu_state {
        my $self            = shift;
        my $last_menu_state = shift;

        $self->{'last_menu_state'} = $last_menu_state;

        return $self->{'last_menu_state'};
    }

    sub cls {
        my $self = shift;

        print "\033[2J";    #clear the screen
        print "\033[0;0H";
    }

    sub process {
        my $self  = shift;
        my $input = shift;

        chomp($input);

        SWITCH: {
            $self->menu_state =~ /^ main $/x && do {
                if($input && $input =~ /^ A $/ix) {
                    $self->menu_state('enter_player_name');
                }
                elsif($input && $input =~ /^ R $/ix) {
                    $self->display_rules;
                }
                elsif($input && $input =~ /^ L $/ix) {
                    $self->list_players;
                }
                elsif($input && $input =~ /^ P $/ix) {
                    if(scalar keys %{ $self->{'players'} } < 2) {
                        $self->error('Must have at least 2 players to begin.');
                    }
                    else {
                        $self->randomize_presents;

                        $self->clear_msg;

                        $self->display_presents;

                        $self->menu_state('display_present_assignments');
                    }
                }
                elsif($input && $input =~ /^ Q $/ix) {
                    exit;
                }
                else {
                    $self->error('Invalid option.');
                }
                last SWITCH;
            };
            $self->menu_state =~ /^ enter_player_name $/x && do {
                if($input) {
                    $self->{'new_player'} = $input;
                    $self->menu_state('enter_player_present_id');
                }
                else {
                    $self->error('Invalid name.');
                }
                last SWITCH;
            };
            $self->menu_state =~ /^ enter_player_present_id $/x && do {
                if($input) {
                    my $found = 0;
                    for my $player(values %{ $self->{'players'} } ) {
                        if($player->{'given_present'} eq $input) {
                            $found = 1;
                            last;
                        }
                    }

                    if($found) {
                        $self->error("\nPresent has already been added for a different player.");
                    }
                    else {
                        $self->{'players'}{ $self->{'new_player'} } = {
                            name             => $self->{'new_player'},
                            given_present    => $input,
                            starting_present => undef,
                            play_order       => 0,
                        };
                        $self->msg( "Added Player $self->{new_player} with Present $input" );
                        $self->menu_state('main');
                    }
                }
                else {
                    $self->error('Invalid name.');
                }
                last SWITCH;
            };
            $self->menu_state =~ /^ display_present_assignments $/x && do {
                if($input && $input =~ /^ C $/ix) {
                    $self->randomize_order;

                    $self->clear_msg;

                    $self->display_order;

                    $self->menu_state('display_play_order');
                }
                elsif($input && $input =~ /^ B $/ix) {
                    $self->menu_state('main');
                }
                else {
                    $self->display_presents;
                    $self->error('Invalid option.');
                }

                last SWITCH;
            };
            $self->menu_state =~ /^ display_play_order $/x && do {
                if($input && $input =~ /^ C $/ix) {
                    $self->menu_state('main');
                }
                elsif($input && $input =~ /^ B $/ix) {
                    $self->clear_msg;

                    $self->display_presents;

                    $self->menu_state('display_present_assignments');
                }
                else {
                    $self->display_order;
                    $self->error('Invalid option.');
                }

                last SWITCH;
            };
        }
    }

    sub error {
        my $self  = shift;
        my $error = shift;

        $self->{'error'} .= $error if $error;

        return $self->{'error'};
    }

    sub clear_error {
        my $self = shift;

        delete $self->{'error'};
    }

    sub render_output {
        my $self = shift;

        if($self->msg) {
            print RESET WHITE  $self->msg . " \n\n";
            $self->clear_msg;
        }

        if($self->error) {
            print RESET GREEN ON_RED  ' ' . $self->error . " \n\n";
            $self->clear_error;
        }
    }

    sub msg {
        my $self = shift;
        my $msg  = shift;

        $self->{'msg'} .= $msg if $msg;

        return $self->{'msg'};
    }

    sub clear_msg {
        my $self = shift;

        delete $self->{'msg'};
    }

    sub cli {
        print RESET WHITE "> "; # User input

        my $input = <>;

        return $input;
    }

    sub list_players {
        my $self = shift;

        $self->msg("Players:\n");

        for my $player(sort { $a->{'name'} cmp $b->{'name'} } values %{ $self->{'players'} }) {
            $self->msg("\t" . $player->{'name'} . ' ( ' . $player->{'given_present'} . " )\n");
        }
    }

    sub randomize_presents {
        my $self = shift;

        no warnings 'recursion'; # With larger data sets we have deep recursion warnings appear

        my @presents = map { $_->{'given_present'} } values %{ $self->{'players'} };

        for my $player( values %{ $self->{'players'} } ) {
            @presents = shuffle @presents;
            #my $starting_present = $presents[0] && $presents[0] eq $player->{'given_present'} ? delete $presents[1] : delete $presents[0];
            my $starting_present = delete $presents[0];
            if(! defined($starting_present)) {
                $self->randomize_presents;
                return;
            }
            $player->{'starting_present'} = $starting_present;
        }
    }

    sub display_presents {
        my $self = shift;

        for my $player(sort { $a->{'play_order'} <=> $b->{'play_order'} } values %{ $self->{'players'} } ) {
            $self->msg( "\t\t" . $player->{'name'} . " => " . $player->{'starting_present'} . "\n" );
        }
    }

    sub randomize_order {
        my $self = shift;

        my @order = shuffle keys %{ $self->{'players'} };

        for(my $i = 0; $i < @order; $i++) {
            $self->{'players'}{ $order[ $i ] }{'play_order'} = $i;
        }
    }

    sub display_order {
        my $self = shift;

        for my $player(sort { $a->{'play_order'} <=> $b->{'play_order'} } values %{ $self->{'players'} } ) {
            $self->msg( "\t\t" . ($player->{'play_order'} + 1) . '. ' . $player->{'name'} . "\n" );
        }
    }

    sub display_rules {
        my $self = shift;

        $self->msg("-===- The Rules -===-\n\n");

        $self->msg("\t1. All gifts should be assigned identifiers, (e.g. number on a sticky note)\n\n");

        $self->msg("\t2. Enter in all players and the gifts they brought by id.\n\n");

        $self->msg("\t3. When play is chosen, gifts are randomly assigned to the players.\n\n");

        $self->msg("\t4. After assignment is completed, choose the continue option to determine the order of play.\n\n");

        $self->msg("\t5. A players turn consists of either opening the gift they have OR swapping with a gift someone else has (wrapped or unwrapped). Players only get one chance to swap.\n\n");

        $self->msg("\t6. When all players have completed their turn the exchange is complete. Of course trading after the exchange could happen :)\n\n");

        $self->msg("\t7. Merry/Happy/etc. <Insert Holiday Here>\n\n");

        $self->msg("\n\t               _..--\"\"-.                  .-\"\"--.._\n");
        $self->msg("\t           _.-'         \\ __...----...__ /         '-._\n");
        $self->msg("\t         .'      .:::...,'              ',...:::.      '.\n");
        $self->msg("\t        (     .'``'''::;                  ;::'''``'.     )\n");
        $self->msg("\t         \\             '-)              (-'             /\n");
        $self->msg("\t          \\             /                \\             /\n");
        $self->msg("\t           \\          .'.-.            .-.'.          /\n");
        $self->msg("\t            \\         | \\0|            |0/ |         /\n");
        $self->msg("\t            |          \\  |   .-==-.   |  /          |\n");
        $self->msg("\t             \\          `/`;          ;`\\`          /\n");
        $self->msg("\t              '.._      (_ |  .-==-.  | _)      _..'\n");
        $self->msg("\t                  `\"`\"-`/ `/'        '\\` \\`-\"`\"`\n");
        $self->msg("\t                       / /`;   .==.   ;`\\ \\\n");
        $self->msg("\t                 .---./_/   \\  .==.  /   \\ \\\n");
        $self->msg("\t                / '.    `-.__)       |    `\"\n");
        $self->msg("\t               | =(`-.        '==.   ;\n");
        $self->msg("\t         jgs    \\  '. `-.           /\n");
        $self->msg("\t                 \\_:_)   `\"--.....-'\n");

    }

1;


package Menu::main;

    use Term::ANSIColor qw(:constants);


    sub render {
       print BOLD WHITE "White Elephant 2.0\n\n";
       print RED "\tOptions\n";
       print GREEN "\t\t[R]ules\n\n";
       print GREEN "\t\t[A]dd Player\n\n";
       print GREEN "\t\t[L]ist Players\n\n";
       print GREEN "\t\t[P]lay!\n\n";
       print GREEN "\t\t[Q]uit!\n\n";
    }

1;

package Menu::enter_player_name;

    use Term::ANSIColor qw(:constants);


    sub render {
       print BOLD WHITE "White Elephant 2.0\n\n";
       print RED "\tPlease enter player name:\n";
    }

1;

package Menu::enter_player_present_id;

    use Term::ANSIColor qw(:constants);


    sub render {
       print BOLD WHITE "White Elephant 2.0\n\n";
       print RED "\tPlease enter player present id:\n";
    }

1;

package Menu::display_present_assignments;

    use Term::ANSIColor qw(:constants);


    sub render {
       print BOLD WHITE "White Elephant 2.0\n\n";
       print RED "\tGive each player the assigned present listed. [C]ontinue or Go [B]ack:\n\n";
    }

1;

package Menu::display_play_order;

    use Term::ANSIColor qw(:constants);


    sub render {
       print BOLD WHITE "White Elephant 2.0\n\n";
       print RED "\tEach player takes their turn in the following order. [C]ontinue or Go [B]ack:\n\n";
    }

1;
