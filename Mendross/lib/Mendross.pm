package Mendross;
use Dancer2;

our $VERSION = '0.1';

get '/' => sub {
    template 'index' => { 'title' => 'Mendross' };
};

post '/cross' => sub {
  my $genes = body_parameters->get('gene');
  my $p_one = body_parameters->get('pog');
  my $p_two = body_parameters->get('ptg');


  ##############################################################
  # Mendross core logic (https://github.com/ElRakabawi/Mendross)
  ##############################################################


  my $len_one = length($p_one); #length of Parent one genotype
  my $len_two = length($p_two); #length of Parent two genotype
  my $alleles = $genes*2; #Number of alleles

  my @POG = (); #Parent One Gametes
  my @PTG = (); #Parent Two Gametes
  my @POS = (); #Parent one step
  my @PTS = (); #Parent two step

  #Computation of monohybrid crossing
  if($genes == 1){
    for(my $i=0; $i<$alleles; $i++){
      $POG[$i] = substr($p_one,$i,1);
      $PTG[$i] = substr($p_two,$i,1);
    }
  }

  my @rows = (["  ","$POG[0]", "$POG[1]"]);
  my @rows_two =([ "$PTG[0]", $PTG[0].$POG[0], $PTG[0].$POG[1]]);
  my @rows_three = ([ "$PTG[1]", $PTG[1].$POG[0], $PTG[1].$POG[1]]);


  # END #


  #Pushing to the template 'index'
    template 'index' => {
      'genes' => $genes,
      'p_one' => $p_one,
      'p_two' => $p_two,
      'rows' => @rows,
      'rows_two' => @rows_two,
      'rows_three' => @rows_three
   };

};

true;
