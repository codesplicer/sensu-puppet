Puppet::Type.newtype(:sensu_client_config) do
  @doc = ""

  def initialize(*args)
    super

    self[:notify] = [
      "Service[sensu-client]",
    ].select { |ref| catalog.resource(ref) }
  end

  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto :present
  end

  newparam(:name) do
    desc "The name of the host"
  end

  newproperty(:client_name) do
    desc ""
  end

  newproperty(:address) do
    desc ""
  end

  newproperty(:subscriptions, :array_matching => :all) do
    desc ""
  end

  newproperty(:safe_mode, :boolean => true) do
    desc "Require checks to be defined on server and client"
    newvalues(:true, :false)
  end

  newproperty(:custom) do
    desc "Custom client variables"

    def is_to_s(hash = @is)
      hash.keys.sort.map {|key| "#{key} => #{hash[key]}"}.join(", ")
    end

    def should_to_s(hash = @should)
      hash.keys.sort.map {|key| "#{key} => #{hash[key]}"}.join(", ")
    end

    defaultto {}
  end

  autorequire(:package) do
    ['sensu']
  end
end
