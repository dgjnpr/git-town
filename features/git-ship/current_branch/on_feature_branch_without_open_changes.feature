Feature: git ship: shipping the current feature branch

  Scenario: local feature branch
    Given I am on a local feature branch
    And the following commit exists in my repository
      | LOCATION | FILE NAME    | FILE CONTENT    |
      | local    | feature_file | feature content |
    When I run `git ship -m 'feature done'`
    Then it runs the Git commands
      | BRANCH  | COMMAND                         |
      | feature | git checkout main               |
      | main    | git fetch --prune               |
      | main    | git rebase origin/main          |
      | main    | git checkout feature            |
      | feature | git merge --no-edit main        |
      | feature | git checkout main               |
      | main    | git merge --squash feature      |
      | main    | git commit -a -m 'feature done' |
      | main    | git push                        |
      | main    | git branch -D feature           |
    And I end up on the "main" branch
    And there are no more feature branches
    And there are no open changes
    And I have the following commits
      | BRANCH | LOCATION         | MESSAGE      | FILES        |
      | main   | local and remote | feature done | feature_file |
    And now I have the following committed files
      | BRANCH | FILES        |
      | main   | feature_file |


  Scenario: feature branch with non-pulled updates in the repo
    Given I am on a feature branch
    And the following commit exists in my repository
      | LOCATION | FILE NAME    | FILE CONTENT    |
      | remote   | feature_file | feature content |
    When I run `git ship -m 'feature done'`
    Then it runs the Git commands
      | BRANCH  | COMMAND                            |
      | feature | git checkout main                  |
      | main    | git fetch --prune                  |
      | main    | git rebase origin/main             |
      | main    | git checkout feature               |
      | feature | git merge --no-edit origin/feature |
      | feature | git merge --no-edit main           |
      | feature | git checkout main                  |
      | main    | git merge --squash feature         |
      | main    | git commit -a -m 'feature done'    |
      | main    | git push                           |
      | main    | git push origin :feature           |
      | main    | git branch -D feature              |
    And I end up on the "main" branch
    And there are no more feature branches
    And there are no open changes
    And I have the following commits
      | BRANCH | LOCATION         | MESSAGE      | FILES        |
      | main   | local and remote | feature done | feature_file |
    And now I have the following committed files
      | BRANCH | FILES        |
      | main   | feature_file |
