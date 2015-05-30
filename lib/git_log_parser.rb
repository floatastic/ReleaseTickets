class GitLogParser
  def initialize(from_version, to_version, tickets_prefix)
    @from_version = from_version
    @to_version = to_version
    @tickets_prefix = tickets_prefix
  end

  def tickets!
    branches = `git ls-remote -t -h`

	abort "Unable to retrieve branches and tags information from remote" if branches.to_s == ''

	regexp_prefix = '([a-zA-Z0-9]{40})\t[a-zA-Z0-9\/]*?\/'
	hash_from = branches[/#{regexp_prefix}#{Regexp.escape(@from_version)}/, 1]
	hash_to = branches[/#{regexp_prefix}#{Regexp.escape(@to_version)}/, 1]

	abort "Unable to get #{@from_version} hash from remote." if hash_from.to_s == ''
	abort "Unable to get #{@to_version} hash from remote." if hash_to.to_s == ''

	tickets_pattern = Regexp.escape(@tickets_prefix) + '[0-9]\+'
	tickets_in_git = `git log #{hash_to}..#{hash_from} --graph --oneline --decorate --no-merges | grep -o '#{tickets_pattern}' | sort | uniq`
	return tickets_in_git.split("\n")
  end
end