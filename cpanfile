requires "Moo";
requires "IO::All";
requires "C::Tokenize";
requires "Regexp::Common";

on 'test' => sub {
  requires "File::Temp";
}
