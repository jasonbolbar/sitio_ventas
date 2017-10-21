use strict;
use Modules::Util;
use Modules::Authentication;
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
	return $content;
}
1;