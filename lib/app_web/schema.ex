defmodule AppWeb.Schema do
  use Absinthe.Schema
  import_types AppWeb.Schema.Types

  query do
    field :recordings, list_of(:recording) do
      resolve &AppWeb.RecordingResolver.all/2
    end

    field :recording, type: :recording do
      arg :id, non_null(:id)
      resolve &AppWeb.RecordingResolver.find/2
    end

    field :themes, list_of(:theme) do
      resolve &AppWeb.ThemeResolver.all/2
    end

  end

  input_object :update_post_params do
    field :author, non_null(:string)
    field :description, non_null(:string)
    field :theme, non_null(:string)
  end

  mutation do
    field :create_recording, type: :recording do
      arg :author, non_null(:string)
      arg :description, non_null(:string)
      arg :theme, non_null(:string)

      resolve &AppWeb.RecordingResolver.create/2
    end

    field :update_recording, type: :recording do
      arg :id, non_null(:integer)
      arg :recording, :update_post_params

      resolve &AppWeb.RecordingResolver.update/2
    end

    field :delete_recording, type: :recording do
      arg :id, non_null(:integer)

      resolve &AppWeb.RecordingResolver.delete/2
    end
  end

end
