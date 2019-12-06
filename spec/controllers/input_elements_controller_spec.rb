require 'rails_helper'

describe InputElementsController do
  render_views

  describe 'by_slide' do
    # Tab 1
    #   SidebarItem 1
    #     Slide 1
    #       InputElement 1
    #       InputElement 2
    #     Slide 2
    #       InputElement 3
    #   SidebarItem 2
    #     Slide 3
    #       InputElement 4
    # Tab 2
    #   SidebarItem 4
    #     Slide 4
    #       InputElement 5
    let!(:t1) { Tab.all.first }
    let!(:t2) { Tab.all.second }

    let!(:si1) { FactoryBot.create(:sidebar_item, tab: t1) }
    let!(:si2) { FactoryBot.create(:sidebar_item, tab: t1) }
    let!(:si3) { FactoryBot.create(:sidebar_item, tab: t2) }

    let!(:sl1) { FactoryBot.create(:slide, sidebar_item: si1) }
    let!(:sl2) { FactoryBot.create(:slide, sidebar_item: si1) }
    let!(:sl3) { FactoryBot.create(:slide, sidebar_item: si2) }
    let!(:sl4) { FactoryBot.create(:slide, sidebar_item: si3) }

    let!(:ie1) { FactoryBot.create(:input_element, slide: sl1) }
    let!(:ie2) { FactoryBot.create(:input_element, slide: sl1) }
    let!(:ie3) { FactoryBot.create(:input_element, slide: sl2) }
    let!(:ie4) { FactoryBot.create(:input_element, slide: sl3) }
    let!(:ie5) { FactoryBot.create(:input_element, slide: sl4) }

    let(:json) do
      get(:by_slide)
      JSON.parse(response.body)
    end

    it 'contains 4 slides' do
      expect(json.length).to eq(4)
    end

    it 'groups sliders by slide' do
      expect(json[0]['input_elements'].length).to eq(2)

      expect(json[0]['input_elements'][0]['key']).to eq(ie1.key)
      expect(json[0]['input_elements'][1]['key']).to eq(ie2.key)

      expect(json[1]['input_elements'][0]['key']).to eq(ie3.key)
      expect(json[2]['input_elements'][0]['key']).to eq(ie4.key)
      expect(json[3]['input_elements'][0]['key']).to eq(ie5.key)
    end

    it 'assigns a path/name to each slide' do
      path = json[0]['path']

      expect(path.length).to eq(3)

      expect(path[0]).to include(t1.key)
      expect(path[1]).to include(si1.key)
      expect(path[2]).to include(sl1.key)
    end

    context 'the inputs' do
      let(:input) { json[0]['input_elements'].first }

      it 'includes each input key' do
        expect(input).to have_key('key')
        expect(input['key']).to eq(ie1.key)
      end

      it 'includes each input translated name' do
        expect(input).to have_key('name')
        expect(input['name']).to include(ie1.key)
      end

      it 'includes each input unit' do
        expect(input).to have_key('unit')
        expect(input['unit']).to eq(ie1.unit)
      end
    end
  end
end
