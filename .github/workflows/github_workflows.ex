defmodule GitHubWorkflows do
  @moduledoc """
  Used by a custom tool to generate GitHub workflows.
  Reduces repetition.
  """

  def get do
    # repo_name = "invoice_generator"
    # app_name = "invoice_generator"

    %{
      "main.yml" => main_workflow(),
      "pr.yml" => pr_workflow(repo_name, app_name)
    }
  end

  defp main_workflow do
    [
      [
        name: "Main",
        on: [
          push: [
            branches: ["main"]
          ]
        ],
        jobs: [
          test: test_job()
        ]
      ]
    ]
  end

  defp pr_workflow(repo_name, app_name) do
    [
      [
        name: "PR",
        on: [
          pull_request: [
            branches: ["main"],

          ]
        ],
        jobs: [
          test: test_job()
        ]
      ]
    ]
  end

  defp test_job do
    [
      name: "Test",
      "runs-on": "ubuntu-latest",
      services: [
        db: [
          image: "postgres:13",
          ports: ["5432:5432"],
          env: [POSTGRES_PASSWORD: "postgres"],
          options:
            "--health-cmd pg_isready --health-interval 10s --health-timeout 5s --health-retries 5"
        ]
      ],
      env: [
        "elixir-version": "1.14.3",
        "otp-version": "25.2.1"
      ],
      steps: [
        [
          uses: "actions/checkout@v2"
        ],
        [
          name: "Set up Elixir",
          uses: "erlef/setup-beam@v1",
          with: [
            "elixir-version": "${{ env.elixir-version }}",
            "otp-version": "${{ env.otp-version }}"
          ]
        ],
        [
          uses: "actions/cache@v2",
          with: [
            path: "_build\ndeps",
            key: "${{ runner.os }}-mix-${{ hashFiles('**/mix.lock') }}",
            "restore-keys": "${{ runner.os }}-mix-"
          ]
        ],
        [
          name: "Install Elixir dependencies",
          run: "mix deps.get"
        ],
        [
          name: "Restore PLT cache",
          uses: "actions/cache@v2",
          id: "plt_cache",
          with: [
            key: "${{ runner.os }}-${{ env.elixir-version }}-${{ env.otp-version }}-v2-plt",
            "restore-keys":
              "${{ runner.os }}-${{ env.elixir-version }}-${{ env.otp-version }}-v2-plt",
            path: "priv/plts"
          ]
        ],
        [
          name: "Create PLTs",
          if: "steps.plt_cache.outputs.cache-hit != 'true'",
          run: "mix dialyzer --plt"
        ],
        [
          uses: "actions/cache@v2",
          with: [
            path: "~/.npm\nassets/node_modules",
            key: "${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}",
            "restore-keys": "${{ runner.os }}-npm-"
          ]
        ],
        [
          name: "Install Node dependencies",
          run: "npm ci --prefix ./assets --prefer-offline --no-audit"
        ],
        [
          name: "Run tests",
          run: "mix ci\nmix ci.migrations"
        ]
      ]
    ]
  end
end
