use strict;
use Modules::Util;
use Modules::Authentication;
use Modules::Http::Request;
package Modules::Renders::NavBar;

my $renderLogin = sub {
	my ($content) = @_;
	my %loginData = Modules::Authentication::isUserAuthenticated() ? 
	('text' => 'Cerrar Sesión', 'url' => '/logout') : 
	('text' => 'Ingresar', 'url' => '/login') ;
	$content = Modules::Util::replace("--login-url--", $loginData{'url'} , $content);
	$content = Modules::Util::replace("--login-text--", $loginData{'text'} , $content);
	return $content; 
};

my $renderIfNotAuthenticated = sub {
	my ($content, $key, $value) = @_;
	my $valueToRender = !Modules::Authentication::isUserAuthenticated() ? $value : '';
	return Modules::Util::replace($key, $valueToRender , $content);
};

my $renderIfAuthenticated = sub  {
	my ($content, $key, $value) = @_;
	my $valueToRender = Modules::Authentication::isUserAuthenticated() ? $value : '';
	return Modules::Util::replace($key, $valueToRender , $content);
};

my $renderAlert = sub {
	my %parameters = Modules::Http::Request::getRequestData();
	my $alert = $parameters{'alert'};
	my $alert_html;
	if (defined $alert) {
		if ($alert eq 'success') {
			$alert_html = Modules::Util::getFile('templates/alert-success.html');
		} elsif ($alert eq 'error') {
			$alert_html = Modules::Util::getFile('templates/alert-error.html');
		}
	}
	return $alert_html;
};

sub render
{
	my ($content) = @_;
	$content = Modules::Util::replace("<nav-bar>", Modules::Util::getFile('templates/nav-bar.html') , $content);
	$content = $renderLogin->($content);
	$content = $renderIfNotAuthenticated->( $content, 
		'<register-link>', 
		'<a href="/sign_in" class="w3-bar-item w3-button w3-border-right">Registrarse</a>'
	);
	$content = $renderIfAuthenticated->( $content, 
		'<shoppings-link>', 
		'<a href="/shoppings" class="w3-bar-item w3-button"><i class="fa fa-shopping-cart"></i></a>'
	);
	$content = $renderIfAuthenticated->( $content, 
		'<new-product-link>', 
		'<a href="/new_product" class="w3-bar-item w3-button">Vender artículo</a>'
	);
	my $alert_message = $renderAlert->();
	if (defined $alert_message) {
		$content = Modules::Util::replace("<alert>", $alert_message, $content);
	}
	return $content;
}
1;