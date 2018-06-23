use strict;
use Modules::Util;
use Modules::Http::Cookie;
package Modules::Renders::Alert;

my $renderAlert = sub {
	my %cookies = Modules::Http::Cookie::getCookies();
	my $alert_html = "";
	if ( $cookies{'Success'} )
	{
		$alert_html .= Modules::Util::replace( '--success--',  Modules::Util::escapeHtml($cookies{'Success'}), Modules::Util::getFile('templates/alert-success.html'));
	}
	if ( $cookies{'Error'} )
	{
		$alert_html .= Modules::Util::replace( '--error--',  Modules::Util::escapeHtml($cookies{'Error'}),  Modules::Util::getFile('templates/alert-error.html'));
	}
	return $alert_html;
};

sub render
{
	my ($content) = @_;
	my $alert_message = $renderAlert->();
	if (defined $alert_message) {
		$content = Modules::Util::replace("<alert>", $alert_message, $content);
	}
	return $content;
}
1;