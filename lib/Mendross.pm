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

    my $rows = [
        ["  ",$POG[0], $POG[1]],
        [ $PTG[0], $PTG[0].$POG[0], $PTG[0].$POG[1] ],
        [ $PTG[1], $PTG[1].$POG[0], $PTG[1].$POG[1] ]
        ];


    #Pushing to the template 'index'
      template 'index' => {
        'r00' => $rows->[0][0],
        'r01' => $rows->[0][1],
        'r02' => $rows->[0][2],
        'r10' => $rows->[1][0],
        'r11' => $rows->[1][1],
        'r12' => $rows->[1][2],
        'r20' => $rows->[2][0],
        'r21' => $rows->[2][1],
        'r22' => $rows->[2][2]
     };
  }
  # END #

  #Computation of Dihybrid crossing
  elsif ($genes == 2){
    for(my $i=0; $i<$alleles; $i++){
      $POS[$i] = substr($p_one,$i,1);
      $PTS[$i] = substr($p_two,$i,1);
    }

    my $m = 0;
    for(my $i=0; $i<$alleles; $i+=2){

      $POG[$i][0] = $POS[$m];
      $POG[$i][1] = $POS[2];
      $POG[$i+1][0] = $POS[$m];
      $POG[$i+1][1] = $POS[3];
      $m++;
    }

    my $n = 0;
    for(my $i=0; $i<$alleles; $i+=2){

      $PTG[$i][0] = $PTS[$n];
      $PTG[$i][1] = $PTS[2];
      $PTG[$i+1][0] = $PTS[$n];
      $PTG[$i+1][1] = $PTS[3];
      $n++;
    }


    my $rows = [
        #header rows
              ["  ",("$POG[0][0]"."$POG[0][1]"), ("$POG[1][0]"."$POG[1][1]"),("$POG[2][0]"."$POG[2][1]"), ("$POG[3][0]"."$POG[3][1]"),],
        #rows
        [ "$PTG[0][0]"."$PTG[0][1]", $PTG[0][0].$POG[0][0].$PTG[0][1].$POG[0][1], $PTG[0][0].$POG[1][0].$PTG[0][1].$POG[1][1],
        $PTG[0][0].$POG[2][0].$PTG[0][1].$POG[2][1], $PTG[0][0].$POG[3][0].$PTG[0][1].$POG[3][1] ], #row 1
        [ "$PTG[1][0]"."$PTG[1][1]", $PTG[1][0].$POG[0][0].$PTG[1][1].$POG[0][1], $PTG[1][0].$POG[1][0].$PTG[1][1].$POG[1][1],
        $PTG[1][0].$POG[2][0].$PTG[1][1].$POG[2][1], $PTG[1][0].$POG[3][0].$PTG[1][1].$POG[3][1] ], #row 2
        [ "$PTG[2][0]"."$PTG[2][1]", $PTG[2][0].$POG[0][0].$PTG[2][1].$POG[0][1], $PTG[2][0].$POG[1][0].$PTG[2][1].$POG[1][1],
        $PTG[2][0].$POG[2][0].$PTG[2][1].$POG[2][1], $PTG[2][0].$POG[3][0].$PTG[2][1].$POG[3][1] ], #row 3
        [ "$PTG[3][0]"."$PTG[3][1]", $PTG[3][0].$POG[0][0].$PTG[3][1].$POG[0][1], $PTG[3][0].$POG[1][0].$PTG[3][1].$POG[1][1],
        $PTG[3][0].$POG[2][0].$PTG[3][1].$POG[2][1], $PTG[3][0].$POG[3][0].$PTG[3][1].$POG[3][1] ], #row 4

      ];




    #Pushing to the template 'index'
      template 'index' => {
        'r00' => $rows->[0][0],
        'r01' => $rows->[0][1],
        'r02' => $rows->[0][2],
        'r03' => $rows->[0][3],
        'r04' => $rows->[0][4],

        'r10' => $rows->[1][0],
        'r11' => $rows->[1][1],
        'r12' => $rows->[1][2],
        'r13' => $rows->[1][3],
        'r14' => $rows->[1][4],

        'r20' => $rows->[2][0],
        'r21' => $rows->[2][1],
        'r22' => $rows->[2][2],
        'r23' => $rows->[2][3],
        'r24' => $rows->[2][4],

        'r30' => $rows->[3][0],
        'r31' => $rows->[3][1],
        'r32' => $rows->[3][2],
        'r33' => $rows->[3][3],
        'r34' => $rows->[3][4],

        'r40' => $rows->[4][0],
        'r41' => $rows->[4][1],
        'r42' => $rows->[4][2],
        'r43' => $rows->[4][3],
        'r44' => $rows->[4][4],



        'ifWorked' => 'Worked!'

     };
  }
  # END #





};

true;
