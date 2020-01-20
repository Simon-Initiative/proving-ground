defmodule LTI.ProviderTest do
  alias LTI.Provider

  use ExUnit.Case, async: true

  describe "validate_parameters" do

    test "returns false if body params is empty" do
      assert Provider.validate_parameters(%{}) === false
    end

    test "return true if parameters are valid" do
      assert Provider.validate_parameters(%{
        lti_version: "LTI-1p0",
        resource_link_id: "some_resource_link_id",
        lti_message_type: "basic-lti-launch-request",
      }) === true
    end

    test "return false if lti_version parameter is missing" do
      assert Provider.validate_parameters(%{
        resource_link_id: "some_resource_link_id",
        lti_message_type: "basic-lti-launch-request",
      }) === false
    end

    test "return false if resource_link_id parameter is missing" do
      assert Provider.validate_parameters(%{
        lti_version: "LTI-1p0",
        lti_message_type: "basic-lti-launch-request",
      }) === false
    end

  end
end
