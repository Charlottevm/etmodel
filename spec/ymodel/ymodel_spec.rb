require "rails_helper"
require 'ymodel'

class YModel::Concrete < YModel::Base
  source_file 'spec/support/ymodel/concrete.yml'
end

class YModel::InvalidConcrete < YModel::Base
  source_file 'spec/support/ymodel/invalid_concrete.yml'
end

describe YModel::Base do
  it "is a class" do
    expect(YModel::Base).to be_a Class
  end

  subject { YModel::Concrete.new }

  it { is_expected.to respond_to :key }
  it { is_expected.to respond_to :id }
  it { is_expected.to respond_to :nl_vimeo_id }
  it { is_expected.to respond_to :en_vimeo_id }
  it { is_expected.to respond_to :position }

  describe '.all' do
    subject { YModel::Concrete.all }
    it { is_expected.to all(be_a YModel::Concrete) }
  end

  describe '.find' do
    subject { YModel::Concrete.find(1) }
    it { is_expected.to be_a YModel::Concrete }
  end

  it "With a missing source" do
    expect{ YModel::InvalidConcrete.all }
      .to raise_error YModel::SourceFileNotFound
  end

  describe "attributes" do
    # We're testing wether data is correctly loaded.
    subject { YModel::Concrete.find(2) }
    it "has the correct key" do
      expect(subject.key).to eq 'demand'
    end

    it "has the correct nl_vimeo_id" do
      expect(subject.nl_vimeo_id).to eq '19658877'
    end

    it "has the correct en_video_id" do
      expect(subject.en_vimeo_id).to eq '20191812'
    end

    it "has the correct position" do
      expect(subject.position).to eq 2
    end
  end
end

describe YModel::Schema do
  let (:schema) do
    YModel::Schema.new([{'key1' => 'value', 'key2' => 'value'},
                        {'key1' => 'value', 'key3' => 'value'}])
  end

  describe 'attributes' do
    subject { schema.attributes }

    it { is_expected.to all(be_a Symbol) }

    it "contains all keys" do
      expect(subject.count).to eq(3)
    end
  end
end
