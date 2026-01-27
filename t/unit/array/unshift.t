=pod

=head1 NAME

unit/array/unshift.t - tests the C<unshift> method

=cut

use Test2::V0;
use Sub::HandlesVia::XS;
use Types::Common -types;

subtest "Basic" => sub {
	Sub::HandlesVia::XS::INSTALL_shvxs_array_unshift( "Local::test_1" => {
		arr_source  => Sub::HandlesVia::XS::ARRAY_SRC_INVOCANT,
	} );

	my $arr = [ 999 ];
	is( Local::test_1( $arr, 1 ), undef );
	is( $arr, [ 1, 999 ] );
	is( Local::test_1( $arr, undef ), undef );
	is( $arr, [ undef, 1, 999 ] );
	is( Local::test_1( $arr, 2, 3, 4 ), undef );
	is( $arr, [ 2, 3, 4, undef, 1, 999 ] );
	is( Local::test_1( $arr ), undef );
	is( $arr, [ 2, 3, 4, undef, 1, 999 ] );
	is( Local::test_1( $arr, 5 ), undef );
	is( $arr, [ 5, 2, 3, 4, undef, 1, 999 ] );
};

done_testing;
