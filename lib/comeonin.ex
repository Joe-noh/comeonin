defmodule Comeonin do
  @moduledoc """
  Comeonin aims to make the secure authorization of users
  more straightforward.

  Comeonin supports bcrypt and pbkdf2_sha512.

  ## Use

  Import, or alias, the algorithm you want to use -- either `Comeonin.Bcrypt`
  or `Comeonin.Pbkdf2`.

  To hash a password with the default options:

      hash = hashpwsalt("difficult2guess")

  See each module's documentation for more information about
  all the available options.

  If you want more control over the generation of the salt, and, in
  the case of pbkdf2, the length of salt, you can use the `gen_salt`
  function and then pass the output to the `hashpass` function.

  To check a password against the stored hash, use the `checkpw`
  function. This takes two arguments: the plaintext password and
  the stored hash:

      checkpw(password, stored_hash)

  There is also a `dummy_checkpw` function, which takes no arguments
  and is to be used when the username cannot be found. It performs a hash,
  but then returns false. This can be used to make user enumeration more
  difficult. However, there are many cases in which an attacker will
  already know the username(s), and in these cases, this function will
  be of little use.

  ## Choosing an algorithm

  Bcrypt and pbkdf2_sha512 are both highly secure key derivation functions.
  They have no known vulnerabilities and their algorithms have been used
  and widely reviewed for at least 10 years. They are also designed
  to be `future-adaptable` (see the section below about speed / complexity
  for more details), and so we do not recommend one over the other.
  
  However, if your application needs to use a hashing function that has been
  recommended by a recognized standards body, then you will need to
  use pbkdf2_sha512, which has been recommended by NIST.

  ## Adjusting the speed / complexity of bcrypt and pbkdf2

  Both bcrypt and pbkdf2 are designed to be computationally intensive and
  slow. This limits the number of attempts an attacker can make within a
  certain time frame. In addition, they can be configured to run slower,
  which can help offset some of the hardware improvements made over time.

  It is recommended to make the key derivation function as slow as the
  user can tolerate. The actual recommended time for the function will vary
  depending on the nature of the application. According to the following NIST
  recommendations (http://csrc.nist.gov/publications/nistpubs/800-132/nist-sp800-132.pdf),
  having the function take several seconds might be acceptable if the user
  only has to login once every session. However, if an application requires
  the user to login several times an hour, it would probably be better to
  limit the hashing function to about 250 milliseconds.

  To help you decide how slow to make the function, this module provides
  convenience timing functions for bcrypt and pbkdf2.

  """

  @doc """
  A function to help the developer decide how many log_rounds to use
  when using bcrypt.

  The number of log_rounds can be increased to make this function more
  complex, and slower. The minimum number is 4 and the maximum is 31.
  The default is 12, but this is not necessarily the recommended number.
  The ideal number of log_rounds will depend on the nature of your application
  and the hardware being used.
  """
  def time_bcrypt(log_rounds \\ 12) do
    {time, _} = :timer.tc(Comeonin.Bcrypt, :hashpwsalt, ["password", log_rounds])
    IO.puts "Log rounds: #{log_rounds}, Time: #{div(time, 1000)} ms"
  end

  @doc """
  A function to help the developer decide how many rounds to use
  when using pbkdf2.

  The number of rounds can be increased to make it slower. The maximum number
  of rounds is 4294967295. The default is 60_000, but this is not necessarily
  the recommended number. The ideal number of log_rounds will depend on the
  nature of your application and the hardware being used.
  """
  def time_pbkdf2(rounds \\ 60_000) do
    {time, _} = :timer.tc(Comeonin.Pbkdf2, :hashpwsalt, ["password", rounds])
    IO.puts "Rounds: #{rounds}, Time: #{div(time, 1000)} ms"
  end
end
