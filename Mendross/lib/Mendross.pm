package Mendross;
use Dancer2;

our $VERSION = '0.1';

get '/' => sub {
    template 'index' => { 'title' => 'Mendross' };
};

post '/draw' => sub {
  my $gene_norm = body_parameters->get('gene');
  my $gene = lc($gene_norm);
  my $pog = body_parameters->get('pog');
  my $ptg = body_parameters->get('ptg');

    template 'index' => {
      'gene' => $gene,
      'pog' => $pog,
      'ptg' => $ptg
   };

};

true;
