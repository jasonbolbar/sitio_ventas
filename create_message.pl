use Modules::Http::Request;
use Modules::Database::Querier;
use Modules::Authentication;

main();

sub main
{
	my %message = Modules::Http::Request::getRequestData('POST');
	my $user_id = Modules::Authentication::getSessionUserId();
	my %row = Modules::Database::Querier::execute('CALL send_message(user_id, message, name, email, phone);');
}